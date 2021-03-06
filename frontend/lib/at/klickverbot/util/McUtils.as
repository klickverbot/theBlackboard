import at.klickverbot.debug.Debug;
import at.klickverbot.debug.DebugLevel;
import at.klickverbot.graphics.Color;
import at.klickverbot.graphics.Point2D;

/**
 * Provides various utils for dealing with MovieClips.
 */
class at.klickverbot.util.McUtils {
   /**
    * Tests if the given MovieClip is somewhere above the other given
    * MovieClip in the display hierachy.
    *
    * @param supposedParent The MovieClip that is supposed to be clip's
    *        "ancestor".
    * @param clip The supposed child MovieClip.
    */
   static public function isParentOf( supposedParent :MovieClip,
      clip :MovieClip ) :Boolean {
      var currentClip :MovieClip = clip;

      // _root's parent is null, so we traverse the display hierachy from
      // bottom to top until we reach _root.
      while ( currentClip != null ) {
         if ( currentClip == supposedParent ) {
            return true;
         }
         currentClip = currentClip._parent;
      }
      return false;
   }

   /**
    * Returns an array containing all MovieClips which have the given MovieClip
    * as their _parent.
    */
   static public function getChildren( parent :MovieClip ) :Array {
      var result :Array = new Array();
      for ( var name :String in parent ) {
         if ( parent[ name ] instanceof MovieClip ) {
            result.push( parent[ name ] );
         }
      }
      return result;
   }

   static public function localToGlobal( parent :MovieClip,
      point :Point2D ) :Point2D {
      var flashPoint :Object = { x: point.x, y: point.y };
      parent.localToGlobal( flashPoint );
      return new Point2D( flashPoint[ "x" ], flashPoint[ "y" ] );
   }

   static public function globalToLocal( parent :MovieClip,
      point :Point2D ) :Point2D {
      var flashPoint :Object = { x: point.x, y: point.y };
      parent.globalToLocal( flashPoint );
      return new Point2D( flashPoint[ "x" ], flashPoint[ "y" ] );
   }

   static public function drawDummyRectangle( target :MovieClip ) :Void {
      target.lineStyle( 0, 0, 0 );

      if( Debug.LEVEL >= DebugLevel.HIGH ) {
         target.beginFill( ( new Color(
            Math.random(), Math.random(), Math.random() ) ).toHex(), 30 );
      } else {
         target.beginFill( 0, 0 );
      }

      target.moveTo( 0, 0 );
      target.lineTo( 1, 0 );
      target.lineTo( 1, 1 );
      target.lineTo( 0, 1 );
      target.lineTo( 0, 0 );

      target.endFill();
   }
}
