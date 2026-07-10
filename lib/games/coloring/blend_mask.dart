import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Aplica un [BlendMode] al hijo (p. ej. [BlendMode.multiply] sobre el color).
/// Así el blanco de un dibujo JPG deja ver la pintura y las líneas negras se quedan.
class BlendMask extends SingleChildRenderObjectWidget {
  final BlendMode blendMode;

  const BlendMask({
    super.key,
    required this.blendMode,
    required Widget super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderBlendMask(blendMode);
  }

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    (renderObject as _RenderBlendMask).blendMode = blendMode;
  }
}

class _RenderBlendMask extends RenderProxyBox {
  BlendMode _blendMode;

  _RenderBlendMask(this._blendMode);

  set blendMode(BlendMode value) {
    if (_blendMode == value) return;
    _blendMode = value;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.saveLayer(
      offset & size,
      Paint()..blendMode = _blendMode,
    );
    super.paint(context, offset);
    context.canvas.restore();
  }
}
