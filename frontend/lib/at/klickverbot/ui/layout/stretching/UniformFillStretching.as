import at.klickverbot.core.CoreObject;
import at.klickverbot.graphics.Point2D;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.layout.stretching.IStretchMode;

class at.klickverbot.ui.layout.stretching.UniformFillStretching extends CoreObject
   implements IStretchMode {

   public function fitToSize( component :IUiComponent, targetSize :Point2D ) :Void {
      var componentSize :Point2D = component.getSize();
      var scaleFactor :Number = Math.max(
         ( targetSize.x / componentSize.x ), ( targetSize.y / componentSize.y ) );
      component.scale( scaleFactor, scaleFactor );
   }
}
