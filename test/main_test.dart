import 'dart:io';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('correctly reads raw rgba', () async {
    final bytes = await File('./test/img.png').readAsBytes();
    final codec = await instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;

    final byteData = await image.toByteData(format: ImageByteFormat.rawRgba);
    final u32 = byteData!.buffer.asUint32List();

    final hexCodes = <String>[];
    for (final pixel in u32) {
      hexCodes.add('#' + pixel.toRadixString(16).padRight(8, '0'));
    }

    expect(
      hexCodes,
      [
        //AABBGGRR
        //First raw, solid colors
        '#ff0000ff', // red
        '#ff00ff00', // green
        '#ffff0000', // blue
        '#ff888888', // grey

        //Second raw, 50% transparent
        '#7f0000ff', // red
        '#7f00ff00', // green
        '#7fff0000', // blue
        '#7f888888', // grey

        //Third raw, 25% transparent
        '#3f0000ff', // red
        '#3f00ff00', // green
        '#3fff0000', // blue
        '#3f888888', // grey

        //Fourth raw, transparent
        '#00000000',
        '#00000000',
        '#00000000',
        '#00000000'
      ],
    );
  });
}
