import 'package:flutter/material.dart';

class Step7Dashboard extends StatefulWidget {
  final String Function(String) t;
  final VoidCallback onBackToHome;
  final VoidCallback onBack;

  const Step7Dashboard({
    super.key,
    required this.t,
    required this.onBackToHome,
    required this.onBack,
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
              // Top row with back and settings icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: widget.onBack,
                    child: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFFF7B119),
                      size: 24,
                    ),
                  ),
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
                'Welcome back',
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
                      'assets/images/indonesia_id_card.jpg',
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
          // Home - navigate back to step 1
          widget.onBackToHome();
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
    // Indonesian KTP (Kartu Tanda Penduduk) style placeholder
    return Container(
      width: 316,
      height: 205,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF5F5DC), Color(0xFFE8E4C9)], // Cream/beige KTP background
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400, width: 1),
      ),
      child: Stack(
        children: [
          // Top header with Indonesian flag colors
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 8,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF0000), Color(0xFFFFFFFF)], // Red and White
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
            ),
          ),
          // Province header
          Positioned(
            top: 15,
            left: 15,
            right: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  'PROVINSI DKI JAKARTA',
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'KOTA JAKARTA SELATAN',
                  style: TextStyle(
                    fontSize: 8,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          // Garuda emblem placeholder (left side)
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.amber.shade200,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.security,
                size: 18,
                color: Colors.brown,
              ),
            ),
          ),
          // NIK Number
          Positioned(
            top: 45,
            left: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'NIK',
                  style: TextStyle(
                    fontSize: 8,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '3175021234567890',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          // Name
          Positioned(
            top: 75,
            left: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Nama',
                  style: TextStyle(
                    fontSize: 8,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'BUDI SANTOSO',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Photo placeholder (right side)
          Positioned(
            top: 45,
            right: 15,
            child: Container(
              width: 70,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                border: Border.all(color: Colors.grey.shade500),
              ),
              child: const Icon(
                Icons.person,
                size: 40,
                color: Colors.grey,
              ),
            ),
          ),
          // Birth info
          Positioned(
            top: 105,
            left: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Tempat/Tgl Lahir',
                  style: TextStyle(
                    fontSize: 8,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'JAKARTA, 15-08-1990',
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          // Address
          Positioned(
            top: 135,
            left: 15,
            right: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Alamat',
                  style: TextStyle(
                    fontSize: 8,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'JL. SUDIRMAN NO. 123',
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          // Valid until
          Positioned(
            bottom: 15,
            left: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Berlaku Hingga',
                  style: TextStyle(
                    fontSize: 8,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'SEUMUR HIDUP',
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
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


