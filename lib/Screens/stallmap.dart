import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Stall {
  final int number;
  final String name;
  final String description;

  Stall({required this.number, required this.name, required this.description});
}

class StallMapScreen extends StatelessWidget {
  StallMapScreen({super.key});

  // 🔢 Stall data
  final List<Stall> stalls = [
    Stall(number: 1, name: 'SUGAR ROSE', description: 'Delicious sweets & pastries'),
    Stall(number: 2, name: 'LUCRA CRAFT', description: 'Handcrafted gifts and decor'),
    Stall(number: 3, name: 'The Wall Affairs', description: 'We create fun and inspiring posters that make any wall look lively and personal. From motivational quotes to aesthetic designs, our posters add a touch of creativity and vibe to every spaceall at an affordable price.'),
    Stall(number: 4, name: 'The Hidden Trove', description: 'We will sell mystery boxes which might contain anything , which can be expensive and precious to bad. There will a variety of boxes. And we may add some games to for entertainment.'),
    Stall(number: 15, name: 'DREAMY ', description: 'Keychains posters polaroids '),
    Stall(number: 16, name: 'Dillydally ', description: 'I make handmade bouquets and other accessories like keychains , pots, and can be customised '),
    Stall(number: 17, name: 'yaadoon ke kalakaar', description: 'Our stall offers a fun and creative Canvas Hand Printing experience where students can make personalized art using their handprints. It’s a perfect way to capture memories with friends, express creativity, or create a unique keepsake. Participants can choose from various colors, themes, and designs to make their canvas truly special. Whether it’s for gifting or decoration, each handprint tells a story of togetherness and individuality. Affordable, artistic, and memorable—our service combines art and emotion, letting you leave your mark—literally! Come, dip your hands in color, and create a masterpiece that lasts forever.'),
    Stall(number: 18, name: 'CrochetByJahn', description: 'Crochet handmade goodies'),
    Stall(number: 23, name: 'Sujal', description: 'decor lights ,phone case, flower bookey etc..'),
    Stall(number: 27, name: 'The Frame & Facet', description: 'Our stall offers a combination of artificial jewellery and Polaroid photographs, catering to students who love style and memories. The jewellery includes trendy earrings, chains, and bracelets that are affordable and easy to pair with everyday outfits. Alongside, we provide instant Polaroid prints where customers can capture and take home their favorite moments from the event. Together, our products blend fashion and sentiment, making them perfect for a youthful campus crowd.'),
    Stall(number: 25, name: 'Mioraah ', description: 'Mioraah Jewels is a creative jewelry brand that brings the joy of design and self-expression to everyone through DIY jewelry-making kits. Each kit is thoughtfully curated with premium materials, elegant designs, and easy-to-follow guides — empowering users to create their own beautiful accessories. Miorah celebrates creativity, individuality, and the art of handmade fashion, making jewelry-making a fun, relaxing, and stylish experience for all ages. ✨'),
    Stall(number: 26, name: 'Spice & Sparkle', description: '🍛 Food Corner: Enjoy delicious and aromatic Veg Biryani, freshly made to satisfy your cravings.💍 Jewellery Zone: Explore beautiful rings, earrings, bracelets, and matching sets to elevate your look.🎨 Poster Corner: Brighten up your room with trendy graphic posters—perfect for dorm or study space décor!'),
    Stall(number: 28, name: 'The Charms Cart', description: 'Jewellery ( bracelets , pendants, earrings, rings)Scented candle KeychainsBag charms Suction stickers'),
    Stall(number: 21, name: 'Rivaayat', description: "Oxidised jewellery combines traditional craftsmanship with rustic charm. Each piece features a distinctive blackened-silver finish that highlights intricate designs and gives a bold, antique look. Perfect for pairing with both ethnic and modern outfits, oxidised jewellery adds grace, elegance, and a hint of vintage beauty to any occasion. Durable, stylish, and affordable Bracelets – Style That Speaks Your PersonalityAdd a touch of elegance to your everyday look with our beautifully crafted bracelets. Designed to suit every mood and occasion, these pieces blend comfort, charm, and sophistication. Whether you prefer minimal elegance or statement style, our bracelets complete your outfit with effortless grace.Pendants – A Spark of Elegance in Every Detail Our pendants are more than just accessories — they’re expressions of individuality. Each pendant is crafted with precision and creativity, making it the perfect highlight for any neckline. From delicate designs to bold statement pieces, they add timeless beauty and meaning to your collection."),
    Stall(number: 29, name: 'Guess the Mystery', description: ""),
    Stall(number: 41, name: 'Amaira', description: "Accessories and gifting "),
    Stall(number: 46, name: 'Spark Station', description: "Our stall provides a light-hearted social interaction experience where participants engage in short, meaningful conversations in small groups. The goal is to encourage new friendships and positive campus bonding in a respectful and enjoyable environment."),
    Stall(number: 48, name: 'Chatore', description: "Food item"),
    Stall(number: 43, name: 'Too Soft To Handle', description: "Soft Toys, Action figure, Mugs, etc"),
    Stall(number: 42, name: 'AURIA', description: "Our stall offers a curated selection of youth-focused lifestyle products that cater to personal care, style, and aesthetic expression. The product range includes solid perfumes for convenient and long-lasting fragrance, hair accessories such as scrunchies and satin thread bands for everyday styling, and makeup brushes as essential beauty tools. We also feature gifting and décor items including golden and red roses and aesthetic posters suitable for room decoration.The aim of the stall is to provide affordable, trendy, and visually appealing products that resonate with the preferences of the student at Bennett University."),
    Stall(number: 40, name: 'Versona', description: "I create handcrafted solid perfumes made with natural wax and premium fragrances. They’re travel-friendly, long-lasting, and eco-conscious. I displayed them at the previous Business Bazaar, where I got great reviews and good sales. This time, I want to reach more people and make my brand better known."),
  ];

  @override
  Widget build(BuildContext context) {
    final topParallel = [46, 47, 48, 49, 50];
    final bottomParallel = [21, 22, 23, 24, 25];
    final leftColumn = [1, 3, 5, 7, 9, 11, 13, 15, 17, 19];
    final rightColumn = [26, 28, 30, 32, 34, 36, 38, 40, 42, 44];

    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Buisness Bazaar Stall Map",
            style: GoogleFonts.recursive(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 23,
            )),
        centerTitle: true,
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.7,
          maxScale: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🔝 Top parallel row (46–50)
                _buildParallelRow(context, topParallel),

                const SizedBox(height: 14),

                // 🛣️ Road and perpendicular stalls
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildVerticalColumn(context, leftColumn),
                    const SizedBox(width: 6),
                    _buildHorizontalRoad(),
                    const SizedBox(width: 6),
                    _buildVerticalColumn(context, rightColumn),
                  ],
                ),

                const SizedBox(height: 14),

                // ⬇️ Bottom parallel row (21–25)
                _buildParallelRow(context, bottomParallel),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ⬇️ Vertical perpendicular stalls (left/right)
  Widget _buildVerticalColumn(BuildContext context, List<int> numbers) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: numbers.map((n) => _stallBox(context, n)).toList(),
    );
  }

  // ⬆️ / ⬇️ Parallel stalls (top/bottom)
  Widget _buildParallelRow(BuildContext context, List<int> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: numbers.map((n) => _parallelStallBox(context, n)).toList(),
    );
  }

  // 🛣️ Road (horizontal, smaller width)
  Widget _buildHorizontalRoad() {
    return Container(
      width: 350,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(painter: _HorizontalRoadPainter()),
          Text(
            "Way to Gobble →",
            style: GoogleFonts.recursive(
              color: Colors.white70,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  // 📦 Perpendicular stall box
  Widget _stallBox(BuildContext context, int number) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: GestureDetector(
        onTap: () => _showStallDetails(context, number),
        child: Container(
          width: 40,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.deepPurpleAccent.withOpacity(0.25),
            border: Border.all(color: Colors.white54, width: 0.8),
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          child: Text(
            number.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
    );
  }

  // 📦 Parallel stall box (top/bottom)
  Widget _parallelStallBox(BuildContext context, int number) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: GestureDetector(
        onTap: () => _showStallDetails(context, number),
        child: Container(
          width: 36,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.purpleAccent.withOpacity(0.25),
            border: Border.all(color: Colors.white54, width: 0.8),
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          child: Text(
            number.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
    );
  }

  // 🪄 Bottom Sheet (modern UI with fixed height & scrollable text)
void _showStallDetails(BuildContext context, int number) {
  final stall = stalls.firstWhere(
    (s) => s.number == number,
    orElse: () => Stall(
      number: number,
      name: 'Available Stall',
      description: 'No details available yet.',
    ),
  );

  showModalBottomSheet(
    backgroundColor: const Color(0xFF1A1A1A),
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (_) {
      final screenHeight = MediaQuery.of(context).size.height;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        height: screenHeight * 0.6, // 🔹 Fixed height (60% of screen)
        padding: const EdgeInsets.fromLTRB(20, 25, 20, 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Stall number and name row
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.deepPurpleAccent.withOpacity(0.25),
                  child: Text(
                    stall.number.toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    stall.name,
                    style: GoogleFonts.recursive(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Divider(color: Colors.white12, thickness: 1),
            const SizedBox(height: 16),

            // 🔹 Scrollable Description with fixed space
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                thickness: 3,
                radius: const Radius.circular(8),
                child: SingleChildScrollView(
                  child: Text(
                    stall.description,
                    style: GoogleFonts.recursive(
                      color: Colors.white70,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Close button
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                minimumSize: const Size(double.infinity, 48),
              ),
              icon: const Icon(Icons.close, color: Colors.white),
              label: const Text(
                "Close",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      );
    },
  );
}

}

// 🎨 Painter for horizontal dashed road
class _HorizontalRoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white70
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    const dashWidth = 15;
    const dashSpace = 10;
    double startX = 10;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, size.height / 2),
          Offset(startX + dashWidth, size.height / 2), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
