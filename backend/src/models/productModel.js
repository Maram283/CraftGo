const pool = require('../config/db');

// ─── GET ALL PRODUCTS (with artisan name + category) ──────────────────────────
// Supports optional filters: category_id, min_price, max_price, search
// Supports sort: newest | price_low | price_high | rating (default: rating)
const getProducts = async ({ categoryId, search, sort, limit = 20, offset = 0 } = {}) => {
  const conditions = ['p.is_available = true'];
  const values = [];
  let idx = 1;

  if (categoryId) {
    conditions.push(`p.category_id = $${idx++}`);
    values.push(categoryId);
  }
  if (search) {
    conditions.push(`(p.title ILIKE $${idx++})`);
    values.push(`%${search}%`);
  }

  const where = conditions.length ? 'WHERE ' + conditions.join(' AND ') : '';

  const orderMap = {
    newest:     'p.created_at DESC',
    price_low:  'p.price ASC',
    price_high: 'p.price DESC',
    rating:     'ap.avg_rating DESC NULLS LAST',
  };
  const order = orderMap[sort] || orderMap.rating;

  values.push(limit, offset);

  const result = await pool.query(`
    SELECT
      p.id,
      p.title,
      p.description,
      p.price,
      p.stock_quantity,
      p.images,
      p.estimated_delivery_days,
      p.views_count,
      p.created_at,
      c.id           AS category_id,
      c.name         AS category_name,
      c.name_ar      AS category_name_ar,
      u.id           AS artisan_id,
      u.full_name    AS artisan_name,
      u.profile_image_url AS artisan_avatar,
      ap.avg_rating  AS artisan_rating,
      ap.total_ratings
    FROM products p
    JOIN users u        ON u.id = p.artisan_id
    LEFT JOIN artisan_profiles ap ON ap.id = p.artisan_id
    LEFT JOIN categories c ON c.id = p.category_id
    ${where}
    ORDER BY ${order}
    LIMIT $${idx++} OFFSET $${idx++}
  `, values);

  return result.rows;
};

// ─── GET SINGLE PRODUCT ────────────────────────────────────────────────────────
const getProductById = async (id) => {
  const result = await pool.query(`
    SELECT
      p.*,
      c.name         AS category_name,
      c.name_ar      AS category_name_ar,
      u.id           AS artisan_id,
      u.full_name    AS artisan_name,
      u.profile_image_url AS artisan_avatar,
      ap.avg_rating  AS artisan_rating,
      ap.total_ratings,
      ap.bio         AS artisan_bio,
      ap.specializations,
      ap.avg_delivery_days,
      ap.response_rate
    FROM products p
    JOIN users u        ON u.id = p.artisan_id
    LEFT JOIN artisan_profiles ap ON ap.id = p.artisan_id
    LEFT JOIN categories c ON c.id = p.category_id
    WHERE p.id = $1 AND p.is_available = true
  `, [id]);

  return result.rows[0];
};

// ─── GET PRODUCTS BY ARTISAN ───────────────────────────────────────────────────
const getProductsByArtisan = async (artisanId) => {
  const result = await pool.query(`
    SELECT p.*, c.name AS category_name, c.name_ar AS category_name_ar
    FROM products p
    LEFT JOIN categories c ON c.id = p.category_id
    WHERE p.artisan_id = $1 AND p.is_available = true
    ORDER BY p.created_at DESC
  `, [artisanId]);

  return result.rows;
};

// ─── INCREMENT VIEW COUNT ──────────────────────────────────────────────────────
const incrementViewCount = async (id) => {
  await pool.query('UPDATE products SET views_count = views_count + 1 WHERE id = $1', [id]);
};

module.exports = {
  getProducts,
  getProductById,
  getProductsByArtisan,
  incrementViewCount,
};