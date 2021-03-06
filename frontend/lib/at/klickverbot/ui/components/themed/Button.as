import at.klickverbot.event.events.ButtonEvent;
import at.klickverbot.event.events.UiEvent;
import at.klickverbot.theme.ClipId;
import at.klickverbot.ui.components.themed.IButtonStateChanger;
import at.klickverbot.ui.components.themed.Static;
import at.klickverbot.util.Delegate;

class at.klickverbot.ui.components.themed.Button extends Static {
   /**
    * Constructor.
    *
    * @param clipId A ClipId object containing the id of the clip that is used
    *        for displaying the button.
    */
   public function Button( clipId :ClipId ) {
      super( clipId );

      m_active = true;
      m_hovering = false;
      m_oneShotMode = false;
   }

   private function createUi() :Boolean {
      if( !super.createUi() ) {
         return false;
      }

      // Setup the interface to the button content states. If the content
      // MovieClip has custom functions for the states, these are used,
      // otherwise, gotoAndPlay() is called on state changes.
      m_state = new IButtonStateChanger();

      bindFunctionOrGotoAndPlay( "active" );
      bindFunctionOrGotoAndPlay( "inactive" );
      bindFunctionOrGotoAndPlay( "hover" );
      bindFunctionOrGotoAndPlay( "press" );
      bindFunctionOrGotoAndPlay( "release", "hover" );
      bindFunctionOrGotoAndPlay( "releaseOutside", "active" );

      var func :Function = Function( m_staticContent[ "getActiveArea" ] );
      if ( func != null ) {
         m_state.getActiveArea = Delegate.create( m_staticContent, func );
      } else {
         m_state.getActiveArea = Delegate.create( m_staticContent,
            function() :MovieClip {
               return this[ "activeArea" ];
            }
         );
      }

      // Bind the handler functions to the active area.
      var active :MovieClip = getMouseoverArea();
      active.onPress = Delegate.create( this, onPress );
      active.onRelease = Delegate.create( this, onRelease );
      active.onReleaseOutside = Delegate.create( this, onReleaseOutside );

      // We are using the standard UiEvents dispatched by McComponent to react
      // to mouseover/-out.
      addEventListener( UiEvent.MOUSE_OVER, this, handleMouseOver );
      addEventListener( UiEvent.MOUSE_OUT, this, handleMouseOut );

      // If the button is not active, put the button content into the "inactive"
      // state. "active" is the default.
      if ( !m_active ) {
         m_state.inactive();
      }

      return true;
   }


   public function destroy() :Void {
      if ( m_onStage ) {
         removeEventListener( UiEvent.MOUSE_OVER, this, handleMouseOver );
         removeEventListener( UiEvent.MOUSE_OUT, this, handleMouseOut );
      }
      super.destroy();
   }

   public function isActive() :Boolean {
      return m_active;
   }

   public function setActive( active :Boolean ) :Void {
      if ( m_onStage ) {
         if ( m_active && !active ) {
            m_state.inactive();
         } else if ( !m_active && active ) {
            if ( m_hovering ) {
               m_state.hover();
            } else {
               m_state.active();
            }
         }
      }
      m_active = active;
   }

   public function get oneShotMode() :Boolean {
      return m_oneShotMode;
   }

   public function set oneShotMode( active :Boolean ) :Void {
      m_oneShotMode = active;
   }

   private function getMouseoverArea() :MovieClip {
      // Only consider the active area for the hovering events.
      var active :MovieClip = m_state.getActiveArea();
      if ( active == null ) {
         active = m_staticContent;
      }
      return active;
   }

   private function bindFunctionOrGotoAndPlay( actionName :String,
      frameName :String ) :Void {
      if ( frameName == null ) {
         frameName = actionName;
      }

      var func :Function = Function( m_staticContent[ actionName ] );
      if ( func != null ) {
         m_state[ actionName ] = Delegate.create( m_staticContent, func );
      } else {
         m_state[ actionName ] = Delegate.create( m_staticContent,
            function() :Void {
              this.gotoAndPlay( frameName );
            }
         );
      }
   }

   /*
    * Handler functions which are connected to the standard UiEvents to update
    * the state on mouseover/-out.
    */
   private function handleMouseOver( event :UiEvent ) :Void {
      m_hovering = true;

      if ( m_active ) {
         m_state.hover();
      }
   }

   private function handleMouseOut( event :UiEvent ) :Void {
      m_hovering = false;

      if ( m_active ) {
         m_state.active();
      }
   }

   /*
    * Handler functions that are hooked up to the active area.
    */
   private function onPress() :Void {
      if ( m_active ) {
         m_state.press();
         dispatchEvent( new ButtonEvent( ButtonEvent.PRESS, this ) );
      }
   }

   private function onRelease() :Void {
      if ( m_active ) {
         m_state.release();
         dispatchEvent( new ButtonEvent( ButtonEvent.RELEASE, this ) );

         if ( m_oneShotMode ) {
            m_active = false;
            m_state.inactive();
         }
      }
   }

   private function onReleaseOutside() :Void {
      m_hovering = false;

      if ( m_active ) {
         m_state.releaseOutside();
         dispatchEvent( new ButtonEvent( ButtonEvent.RELEASE_OUTSIDE, this ) );
      }
   }

   private var m_active :Boolean;
   private var m_hovering :Boolean;
   private var m_oneShotMode :Boolean;
   private var m_state :IButtonStateChanger;
}
