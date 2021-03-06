import at.klickverbot.debug.Debug;
import at.klickverbot.event.events.UiEvent;
import at.klickverbot.graphics.Point2D;
import at.klickverbot.theme.ClipId;
import at.klickverbot.ui.components.IUiComponent;
import at.klickverbot.ui.components.ScaleGrid;
import at.klickverbot.ui.components.TextFieldWrapperComponent;
import at.klickverbot.ui.components.themed.Static;
import at.klickverbot.ui.layout.ScaleGridCell;
import at.klickverbot.ui.mouse.PointerManager;
import at.klickverbot.util.Delegate;

class at.klickverbot.ui.components.themed.TextBox extends Static
   implements IUiComponent {

   public function TextBox( clipId :ClipId ) {
      super( clipId );

      m_textFieldContainer = new ScaleGrid();
   }

   private function createUi() :Boolean {
      if( !super.createUi() ) {
         return false;
      }

      m_textField = m_staticContent[ TEXT_FIELD_NAME ];
      if ( m_textField == null ) {
         Debug.LIBRARY_LOG.error( "Attempted to create a TextBox using a " +
            "clip that does not have a TextField: " + this );
         super.destroy();
         return false;
      }

      m_background = m_staticContent[ BACKGROUND_NAME ];

      m_textFieldContainer.setCellSizes(
         m_textField._x,
         m_staticContent._width - m_textField._x - m_textField._width,
         m_textField._y,
         m_staticContent._height - m_textField._y - m_textField._height
      );

      var wrapper :TextFieldWrapperComponent =
         new TextFieldWrapperComponent( m_textField );
      m_textFieldContainer.addContent( ScaleGridCell.CENTER, wrapper );
      m_textFieldContainer.create( m_container );

      // Install handlers to update the background when the textfield
      // gets/looses focus.
      m_textField.onSetFocus = Delegate.create( this, gotFocus );
      m_textField.onKillFocus = Delegate.create( this, lostFocus );

      // Also focus the textfield when the background is pressed.
      if ( m_background != null ) {
         m_background.onRelease = Delegate.create( this, backgroundClicked );

         // Adding an onRelease handler causes Flash to add the MovieClip to
         // the tab sequence, which is obviously unwanted for the background.
         m_background.tabEnabled = false;
      }

      // Hide any custom pointer when the mouse is over the textfield because
      // the caret cursor is displayed by the system then (there is no known
      // workaround for this).
      wrapper.addEventListener( UiEvent.MOUSE_OVER, this, handleMouseOver );
      wrapper.addEventListener( UiEvent.MOUSE_OUT, this, handleMouseOut );

      m_textField.text = "";

      return true;
   }

   public function resize( width :Number, height :Number ) :Void {
      if ( !checkOnStage( "resize" ) ) return;

      m_textFieldContainer.resize( width, height );

      if ( m_background != null ) {
         m_background._width = width;
         m_background._height = height;
      }
   }

   public function scale( xScaleFactor :Number, yScaleFactor :Number ) :Void {
      if ( !checkOnStage( "scale" ) ) return;

      var size :Point2D = getSize();
      resize( size.x * xScaleFactor, size.y * yScaleFactor );
   }

   // TODO: Quick'n'dirty, swap out for a m_text property that can be set before the component is put on stage.
   public function get text() :String {
      return m_textField.text;
   }
   public function set text( to :String ) :Void {
      m_textField.text = to;
   }

   private function gotFocus() :Void {
      if ( m_background != null ) {
         m_background.gotoAndPlay( "focus" );
      }
   }

   private function lostFocus() :Void {
      if ( m_background != null ) {
         m_background.gotoAndPlay( "active" );
      }
   }

   private function handleMouseOver() :Void {
      PointerManager.getInstance().suspendCustomPointer();
      Mouse.hide();
   }

   private function handleMouseOut() :Void {
      PointerManager.getInstance().resumeCustomPointer();
   }

   private function backgroundClicked() :Void {
      Selection.setFocus( m_textField );
   }

   private static var TEXT_FIELD_NAME :String = "textField";
   private static var BACKGROUND_NAME :String = "background";

   private var m_textField :TextField;
   private var m_background :MovieClip;
   private var m_textFieldContainer :ScaleGrid;
}
