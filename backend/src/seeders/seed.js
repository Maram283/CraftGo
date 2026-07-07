// backend/src/seeders/seed.js
// Run with:  node src/seeders/seed.js
// Clears and re-seeds: categories, artisan users + profiles, products

const pool = require('../config/db');
const bcrypt = require('bcrypt');

async function seed() {
  console.log('🌱 Starting seed...\n');

  // ── 1. Categories ──────────────────────────────────────────────────────────
  console.log('── Categories ──────────────────────────');
  const categoryRows = [
    ['Textile',     'منسوجات',     'Embroidery, weaving, knitting, and fabric arts'],
    ['Woodwork',    'أعمال خشبية', 'Wood carving, furniture, and wooden crafts'],
    ['Calligraphy', 'خط عربي',     'Arabic calligraphy, painting, and lettering'],
    ['Jewelry',     'مجوهرات',     'Handmade jewelry and accessories'],
    ['Ceramics',    'سيراميك',     'Pottery, ceramics, and clay crafts'],
    ['Painting',    'رسم',         'Painting and fine art'],
    ['Macrame',     'ماكراميه',    'Macrame, rope art, and fiber crafts'],
  ];

  const cats = {};
  for (const [name, name_ar, description] of categoryRows) {
    // Upsert so running the seeder multiple times is safe
    const r = await pool.query(`
      INSERT INTO categories (name, name_ar, description)
      VALUES ($1, $2, $3)
      ON CONFLICT (name) DO UPDATE SET name_ar = EXCLUDED.name_ar
      RETURNING id, name
    `, [name, name_ar, description]);
    cats[r.rows[0].name] = r.rows[0].id;
    console.log(`  ✓ ${r.rows[0].name}  (${r.rows[0].id})`);
  }

  // ── 2. Artisan users + profiles ────────────────────────────────────────────
  console.log('\n── Artisans ─────────────────────────────');
  const passwordHash = await bcrypt.hash('password123', 10);

  const artisanData = [
    {
      email: 'amjad@craftgo.ps', full_name: 'أمجد الخطيب', phone: '0591000001',
      bio: 'حرفي متخصص في نحت الخشب وصناعة الأثاث التراثي الفلسطيني بخبرة تجاوزت ١٥ عاماً.',
      specializations: ['Woodwork'], avg_rating: 4.9, total_ratings: 52,
    },
    {
      email: 'fatima@craftgo.ps', full_name: 'فاطمة محمود', phone: '0591000002',
      bio: 'أعشق التطريز الفلسطيني الأصيل وأحاول من خلاله الحفاظ على الموروث الثقافي.',
      specializations: ['Textile'], avg_rating: 4.8, total_ratings: 74,
    },
    {
      email: 'iyad@craftgo.ps', full_name: 'إياد الكردي', phone: '0591000003',
      bio: 'أشكّل الطين وأصنع منه روائع خزفية تجمع بين الجمال والوظيفة.',
      specializations: ['Ceramics'], avg_rating: 5.0, total_ratings: 31,
    },
    {
      email: 'hana@craftgo.ps', full_name: 'هنا سلامة', phone: '0591000004',
      bio: 'مصممة مجوهرات يدوية من الفضة والنحاس مستوحاة من الفلكلور الفلسطيني.',
      specializations: ['Jewelry'], avg_rating: 4.7, total_ratings: 28,
    },
    {
      email: 'omar@craftgo.ps', full_name: 'عمر السيد', phone: '0591000005',
      bio: 'فنان تشكيلي يرسم اللوحات والجداريات بأسلوب يمزج بين المعاصرة والتراث.',
      specializations: ['Painting', 'Calligraphy'], avg_rating: 4.6, total_ratings: 19,
    },
  ];

  const artisanIds = {};
  for (const a of artisanData) {
    // Upsert user
    const userResult = await pool.query(`
      INSERT INTO users (email, password_hash, full_name, phone, role, is_email_verified)
      VALUES ($1, $2, $3, $4, 'artisan', true)
      ON CONFLICT (email) DO UPDATE SET full_name = EXCLUDED.full_name
      RETURNING id, full_name
    `, [a.email, passwordHash, a.full_name, a.phone]);

    const userId = userResult.rows[0].id;
    artisanIds[a.email] = userId;

    // Upsert artisan profile
    await pool.query(`
      INSERT INTO artisan_profiles
        (id, bio, specializations, offers_ready_made, offers_custom,
         avg_rating, total_ratings, is_approved, availability_status)
      VALUES ($1, $2, $3, true, true, $4, $5, true, 'active')
      ON CONFLICT (id) DO UPDATE
        SET bio = EXCLUDED.bio,
            avg_rating = EXCLUDED.avg_rating,
            total_ratings = EXCLUDED.total_ratings
    `, [userId, a.bio, a.specializations, a.avg_rating, a.total_ratings]);

    console.log(`  ✓ ${userResult.rows[0].full_name}  (${userId})`);
  }

  // ── 3. Products ────────────────────────────────────────────────────────────
  console.log('\n── Products ─────────────────────────────');

  // Delete existing seeded products so re-running is idempotent
  await pool.query(`
    DELETE FROM products
    WHERE artisan_id = ANY($1::uuid[])
  `, [Object.values(artisanIds)]);

  const products = [
    // Fatima — Textile
    {
      artisan: 'fatima@craftgo.ps', category: 'Textile',
      title: 'سجادة صوفية مطرزة',
      description: 'قطعة تطريز يدوية فريدة من نوعها تعكس التراث الفلسطيني الأصيل، مصنوعة من صوف طبيعي عالي الجودة.',
      price: 52.00, stock_quantity: 5, estimated_delivery_days: 3,
    },
    {
      artisan: 'fatima@craftgo.ps', category: 'Textile',
      title: 'وشاح صوف منسوج يدوياً',
      description: 'وشاح دافئ بألوان تقليدية فلسطينية، مثالي كهدية.',
      price: 22.00, stock_quantity: 12, estimated_delivery_days: 2,
    },
    {
      artisan: 'fatima@craftgo.ps', category: 'Textile',
      title: 'مفرش طاولة مطرز',
      description: 'مفرش طاولة يدوي الصنع بنقوش فلسطينية تقليدية، مثالي لإضفاء لمسة تراثية على منزلك.',
      price: 38.00, stock_quantity: 7, estimated_delivery_days: 3,
    },
    // Amjad — Woodwork
    {
      artisan: 'amjad@craftgo.ps', category: 'Woodwork',
      title: 'صندوق خشبي محفور',
      description: 'صندوق من خشب الزيتون منقوش بنقوش عربية إسلامية تقليدية، يصلح للمجوهرات أو كتذكار.',
      price: 60.00, stock_quantity: 3, estimated_delivery_days: 5,
    },
    {
      artisan: 'amjad@craftgo.ps', category: 'Woodwork',
      title: 'رف خشبي منحوت',
      description: 'رف جداري من خشب الجوز منحوت يدوياً بزخارف عربية أصيلة.',
      price: 85.00, stock_quantity: 4, estimated_delivery_days: 7,
    },
    // Iyad — Ceramics
    {
      artisan: 'iyad@craftgo.ps', category: 'Ceramics',
      title: 'إبريق فخاري تقليدي',
      description: 'إبريق مصنوع يدوياً من الطين الفلسطيني الطبيعي، مطلي بألوان تقليدية.',
      price: 28.00, stock_quantity: 8, estimated_delivery_days: 4,
    },
    {
      artisan: 'iyad@craftgo.ps', category: 'Ceramics',
      title: 'طبق خزفي مرسوم',
      description: 'طبق خزفي بحجم متوسط، مرسوم يدوياً بدقة متناهية بألوان الطبيعة الفلسطينية.',
      price: 40.00, stock_quantity: 6, estimated_delivery_days: 4,
    },
    {
      artisan: 'iyad@craftgo.ps', category: 'Ceramics',
      title: 'طقم أكواب فخارية',
      description: 'طقم من ٤ أكواب فخارية مصنوعة يدوياً، مثالية للشاي والقهوة العربية.',
      price: 55.00, stock_quantity: 5, estimated_delivery_days: 5,
    },
    // Hana — Jewelry
    {
      artisan: 'hana@craftgo.ps', category: 'Jewelry',
      title: 'خاتم فضة مصنوع يدوياً',
      description: 'خاتم من الفضة الإسترليني ٩٢٥ مزخرف بنقوش فلسطينية تقليدية.',
      price: 35.00, stock_quantity: 10, estimated_delivery_days: 3,
    },
    {
      artisan: 'hana@craftgo.ps', category: 'Jewelry',
      title: 'قلادة نحاسية مزخرفة',
      description: 'قلادة من النحاس المشغول يدوياً مستوحاة من التراث الكنعاني.',
      price: 45.00, stock_quantity: 8, estimated_delivery_days: 3,
    },
    // Omar — Painting
    {
      artisan: 'omar@craftgo.ps', category: 'Painting',
      title: 'لوحة القدس العتيقة',
      description: 'لوحة زيتية تصوّر أزقة القدس العتيقة بأسلوب واقعي يجمع بين التفاصيل المعمارية والروح الروحانية للمدينة.',
      price: 120.00, stock_quantity: 2, estimated_delivery_days: 2,
    },
    {
      artisan: 'omar@craftgo.ps', category: 'Calligraphy',
      title: 'لوحة خط عربي — بسملة',
      description: 'لوحة خط عربي بالبسملة بخط الثلث، مكتوبة بالحبر الذهبي على ورق كانسون.',
      price: 75.00, stock_quantity: 5, estimated_delivery_days: 3,
    },
  ];

  let inserted = 0;
  for (const p of products) {
    const artisanId = artisanIds[p.artisan];
    const catId = cats[p.category];

    // Log mismatches instead of silently skipping
    if (!artisanId) { console.error(`  ✗ No artisan ID for ${p.artisan}`); continue; }
    if (!catId)     { console.error(`  ✗ No category ID for ${p.category}`); continue; }

    try {
      const r = await pool.query(`
        INSERT INTO products
          (artisan_id, category_id, title, description,
           price, stock_quantity, estimated_delivery_days,
           shipping_cost, is_available)
        VALUES ($1, $2, $3, $4, $5, $6, $7, 0, true)
        RETURNING id, title
      `, [artisanId, catId, p.title, p.description,
          p.price, p.stock_quantity, p.estimated_delivery_days]);

      console.log(`  ✓ ${r.rows[0].title}  (${r.rows[0].id})`);
      inserted++;
    } catch (err) {
      console.error(`  ✗ Failed to insert "${p.title}": ${err.message}`);
    }
  }

  console.log(`\n✅ Done! Inserted ${inserted}/${products.length} products.`);
  console.log('\nArtisan credentials (password: password123):');
  artisanData.forEach(a => console.log(`  ${a.email}`));

  await pool.end();
}

seed().catch(err => {
  console.error('\n❌ Seed failed:', err.message);
  pool.end();
  process.exit(1);
});