import 'package:flutter/material.dart';

class Step7Dashboard extends StatefulWidget {
  final String Function(String) t;
  final VoidCallback onBackToHome;

  const Step7Dashboard({
    super.key,
    required this.t,
    required this.onBackToHome,
  });

  @override
  State<Step7Dashboard> createState() => _Step7DashboardState();
}

class _Step7DashboardState extends State<Step7Dashboard> {
  int _selectedTab = 0; // 0: NRIC, 1: Driving License, 2: What is this?
  int _selectedNavIndex = 0; // 0: Home, 1: Scan, 2: Inbox

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Blue header section
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
          decoration: const BoxDecoration(
            color: Color(0xFF275695),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row with settings icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 24),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(
                      Icons.settings,
                      color: Color(0xFFF7B119),
                      size: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Welcome text
              const Text(
                'Welcome back,',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'LOREM IPSUM',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              // My Cards header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Cards',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {},
                        child: const Icon(
                          Icons.visibility_off,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Tab buttons (NRIC, Driving License, What is this?)
              Row(
                children: [
                  _buildTabButton('NRIC', 0),
                  const SizedBox(width: 8),
                  _buildTabButton('Driving License', 1),
                  const SizedBox(width: 8),
                  _buildTabButton('What is this?', 2),
                ],
              ),
              const SizedBox(height: 20),
              // ID Card Image
              Center(
                child: Container(
                  width: 316,
                  height: 205,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/malaysia_id_card.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholderIdCard();
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Show barcode button
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.qr_code,
                      color: Color(0xFFF7B119),
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Show barcode',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF7B119),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // White content section
        Expanded(
          child: Container(
            color: const Color(0xFFF3F6FA),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // My Profile section header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'My Profile',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'View all',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF33568F),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Profile icons row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildProfileItem(Icons.person_outline, 'Personal'),
                        _buildProfileItem(Icons.attach_money, 'Finance'),
                        _buildProfileItem(Icons.directions_car, 'Vehicle &\nDriving Li...'),
                        _buildProfileItem(Icons.home_outlined, 'Family'),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // Favourites section header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Favourites',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Edit Favourites',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF33568F),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Bottom navigation bar
        Container(
          height: 83,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: Colors.black.withOpacity(0.1),
                width: 0.5,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Home', 0),
              _buildNavItem(Icons.qr_code_scanner, 'Scan', 1, isSpecial: true),
              _buildNavItem(Icons.mail_outline, 'Inbox', 2),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabButton(String text, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF7B119) : const Color(0xFFE3E3E3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFFAF5E4),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            size: 32,
            color: const Color(0xFF33568F),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, {bool isSpecial = false}) {
    final isSelected = _selectedNavIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedNavIndex = index;
        });
        if (index == 0) {
          // Home - could navigate back
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isSpecial)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 24,
                color: Colors.white,
              ),
            )
          else
            Icon(
              icon,
              size: 24,
              color: isSelected ? const Color(0xFFF7B119) : Colors.black,
            ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? const Color(0xFFF7B119) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderIdCard() {
    return Container(
      width: 316,
      height: 205,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4DA3E0), Color(0xFF2B7CB3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 15,
            left: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'KAD PENGENALAN',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'MALAYSIA',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'IDENTITY CARD',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE74C3C),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'MyKad',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            top: 70,
            left: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '010101-01-0000',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'LOREM IPSUM',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'NO 123 LOREM IPSUM',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'DOLOR SIT AMET',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

