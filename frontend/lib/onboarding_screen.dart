import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      "title": "Smart ATS Analysis",
      "description":
          "Analyze your resume with cutting-edge AI to boost your hiring potential. Receive detailed feedback and ATS compatibility scores.",
      "image": "assets/images/image2.png", // Replace with your asset path
    },
    {
      "title": "Personalized Suggestions",
      "description":
          "Get tailored insights on how to improve your resume and align it with industry expectations for maximum impact.",
      "image": "assets/images/image3.png", // Replace with your asset path
    },
    {
      "title": "Job-Winning Features",
      "description":
          "Highlight your strengths and skills effectively using smart algorithms designed to help you stand out.",
      "image": "assets/images/image4.png", // Replace with your asset path
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _currentPage != 0
          ? AppBar(
              backgroundColor: Colors.black,
              foregroundColor: Colors.black,
              leading: IconButton(
                  onPressed: () {
                    _pageController.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
            )
          : null,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _slides.length,
              itemBuilder: (context, index) {
                return _buildSlide(
                  _slides[index]["title"]!,
                  _slides[index]["description"]!,
                  _slides[index]["image"]!,
                );
              },
            ),
          ),
          _buildIndicators(),
          SizedBox(height: 20),
          _buildActionButton(),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSlide(String title, String description, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 200), // Replace with your image
          SizedBox(height: 40),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.orangeAccent,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _slides.length,
        (index) => AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: _currentPage == index ? 12 : 8,
          height: _currentPage == index ? 12 : 8,
          margin: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index ? Colors.orangeAccent : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return ElevatedButton(
      onPressed: () {
        if (_currentPage == _slides.length - 1) {
          // Navigate to ResumeUploadScreen only on the last slide
          Navigator.pushReplacementNamed(context, '/ResumeUploadScreen');
        } else {
          // Navigate to the next slide
          _pageController.nextPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orangeAccent,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        _currentPage == _slides.length - 1 ? "Get Started" : "Next",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
