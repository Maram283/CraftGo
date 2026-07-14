import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminUsersScreen extends StatefulWidget {
  final bool isArabic;
  final bool isDarkMode;

  const AdminUsersScreen({
    super.key,
    required this.isArabic,
    required this.isDarkMode,
  });

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _MockUser {
  final String id;
  final String name;
  final String email;
  final String phone;
  final bool isCraftsman;
  bool isActive;
  final String avatarUrl;

  _MockUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.isCraftsman,
    required this.isActive,
    required this.avatarUrl,
  });
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  int _selectedTabIndex = 0; // 0: Clients, 1: Craftsmen
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  late Color _bgColor;
  late Color _surfaceColor;
  late Color _accentColor;
  late Color _textColor;
  late Color _subtitleColor;

  final List<_MockUser> _users = [
    _MockUser(
      id: '1',
      name: 'Ahmed Ali',
      email: 'ahmed@example.com',
      phone: '+971 50 123 4567',
      isCraftsman: false,
      isActive: true,
      avatarUrl: 'https://i.pravatar.cc/150?u=1',
    ),
    _MockUser(
      id: '2',
      name: 'Sara Khan',
      email: 'sara@example.com',
      phone: '+971 50 987 6543',
      isCraftsman: false,
      isActive: false,
      avatarUrl: 'https://i.pravatar.cc/150?u=2',
    ),
    _MockUser(
      id: '3',
      name: 'Mahmoud Hassan',
      email: 'mahmoud.h@craftgo.com',
      phone: '+971 55 555 1234',
      isCraftsman: true,
      isActive: true,
      avatarUrl: 'https://i.pravatar.cc/150?u=3',
    ),
    _MockUser(
      id: '4',
      name: 'Youssef Omar',
      email: 'youssef@craftgo.com',
      phone: '+971 52 333 4444',
      isCraftsman: true,
      isActive: false,
      avatarUrl: 'https://i.pravatar.cc/150?u=4',
    ),
  ];

  String t(String ar, String en) => widget.isArabic ? ar : en;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleUserStatus(_MockUser user) {
    setState(() {
      user.isActive = !user.isActive;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          t(
            'تم ${user.isActive ? "تفعيل" : "حظر"} المستخدم ${user.name}',
            'User ${user.name} has been ${user.isActive ? "activated" : "suspended"}',
          ),
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
        backgroundColor: _accentColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _bgColor = widget.isDarkMode
        ? const Color(0xFF0D1420)
        : const Color(0xFFF5F6F8);
    _surfaceColor = widget.isDarkMode
        ? const Color(0xFF1C2431)
        : Colors.white;
    _accentColor = widget.isDarkMode
        ? const Color(0xFFD4A017)
        : const Color(0xFF0D1B33);
    _textColor = widget.isDarkMode ? Colors.white : Colors.black87;
    _subtitleColor = widget.isDarkMode ? Colors.white70 : Colors.black54;

    final filteredUsers = _users.where((u) {
      final matchesTab = _selectedTabIndex == 0 ? !u.isCraftsman : u.isCraftsman;
      final matchesSearch = u.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          u.phone.contains(_searchQuery);
      return matchesTab && matchesSearch;
    }).toList();

    return Directionality(
      textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Container(
        color: _bgColor,
        child: Column(
          children: [
            _buildHeader(),
            _buildTabs(),
            Expanded(
              child: filteredUsers.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        return _buildUserCard(filteredUsers[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t('إدارة المستخدمين', 'User Management'),
            style: GoogleFonts.arefRuqaa(
              color: _textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: _bgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _accentColor.withValues(alpha: 0.1),
              ),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              style: TextStyle(color: _textColor, fontFamily: 'Cairo'),
              decoration: InputDecoration(
                hintText: t('ابحث بالاسم أو رقم الهاتف...', 'Search by name or phone...'),
                hintStyle: TextStyle(color: _subtitleColor, fontFamily: 'Cairo'),
                prefixIcon: Icon(Icons.search, color: _accentColor),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: _surfaceColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildTabItem(t('الزبائن', 'Clients'), 0),
            _buildTabItem(t('الحرفيين', 'Craftsmen'), 1),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isSelected ? _accentColor : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: isSelected
                  ? (widget.isDarkMode ? Colors.black87 : Colors.white)
                  : _subtitleColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontFamily: 'Cairo',
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 64, color: _subtitleColor.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(
            t('لا يوجد مستخدمين', 'No users found'),
            style: TextStyle(color: _subtitleColor, fontSize: 16, fontFamily: 'Cairo'),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(_MockUser user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: _accentColor.withValues(alpha: 0.1),
            child: Icon(Icons.person, color: _accentColor, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        user.name,
                        style: TextStyle(
                          color: _textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Cairo',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildStatusChip(user.isActive),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: TextStyle(color: _subtitleColor, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  user.phone,
                  style: TextStyle(color: _subtitleColor, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _buildActionButton(user),
        ],
      ),
    );
  }

  Widget _buildStatusChip(bool isActive) {
    final color = isActive ? Colors.green : Colors.redAccent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        isActive ? t('نشط', 'Active') : t('محظور', 'Suspended'),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }

  Widget _buildActionButton(_MockUser user) {
    final isSuspendAction = user.isActive;
    final color = isSuspendAction ? Colors.redAccent : Colors.green;

    return InkWell(
      onTap: () => _toggleUserStatus(user),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.8),
              color,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          isSuspendAction ? t('حظر', 'Suspend') : t('تفعيل', 'Activate'),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            fontFamily: 'Cairo',
          ),
        ),
      ),
    );
  }
}
