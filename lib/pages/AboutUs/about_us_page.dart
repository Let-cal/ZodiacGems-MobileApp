import 'package:flutter/material.dart';

import '../NavBar/nav_bar.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  _AboutUsPageState get createState => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  int _selectedIndex = 4; // Default to 'About' page index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildMissionSection(),
            const SizedBox(height: 20),
            _buildTeamSection(),
            const SizedBox(height: 20),
            _buildFooter(),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/addCart');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/search');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
      case 4:
        break;
      default:
        break;
    }

    // Update selected index only if navigation occurs
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Container(
          height: 250,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  'https://tinypic.host/images/2024/07/11/Screenshot-2024-07-11-165058.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 250,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.7), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        const Positioned(
          bottom: 20,
          left: 20,
          child: Text(
            'About Us',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMissionSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Our Mission',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'At Zodiac Accessories, we believe in the power of the stars. Our mission is to provide you with the finest quality accessories that not only enhance your style but also resonate with your zodiac sign. Our curated collections are designed to bring out the best in you and align with your astrological identity.',
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          const SizedBox(height: 20),
          Image.network(
            'https://images.unsplash.com/photo-1614089254151-676cc373b01e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwzfHx6b2RpYWN8ZW58MHx8fHwxNzIwNjkxNzI5fDA&ixlib=rb-4.0.3&q=80&w=1080', // Replace with your image URL
            height: 200,
            width: 400,
          ),
        ],
      ),
    );
  }

  Widget _buildTeamSection() {
    return Container(
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Meet the Team',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Our team is passionate about astrology and fashion. Meet the people who make Zodiac Accessories a unique and beloved brand.',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTeamMember(
                  'https://tinypic.host/images/2024/07/11/imagef16847d5ee20ce77.png',
                  'John Doe',
                  'Founder & CEO',
                ),
                _buildTeamMember(
                  'https://tinypic.host/images/2024/07/11/imagef16847d5ee20ce77.png',
                  'Jane Smith',
                  'Chief Designer',
                ),
                _buildTeamMember(
                  'https://tinypic.host/images/2024/07/11/imagef16847d5ee20ce77.png',
                  'Michael Brown',
                  'Marketing Head',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMember(String imageUrl, String name, String role) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(imageUrl),
        ),
        const SizedBox(height: 10),
        Text(
          name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          role,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact Us',
            style: TextStyle(
                fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Email: letrancatlam123@gmail.com',
            style: TextStyle(fontSize: 16, color: Colors.grey[300]),
          ),
          const SizedBox(height: 5),
          Text(
            'Phone: +84 964829558',
            style: TextStyle(fontSize: 16, color: Colors.grey[300]),
          ),
          const SizedBox(height: 20),
          Text(
            'Follow us on social media',
            style: TextStyle(fontSize: 16, color: Colors.grey[300]),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
