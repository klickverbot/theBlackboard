import at.klickverbot.core.CoreObject;
import at.klickverbot.event.events.Event;
import at.klickverbot.ui.animation.Animation;
import at.klickverbot.ui.animation.IAnimation;
import at.klickverbot.util.EnterFrameBeacon;

class at.klickverbot.ui.animation.Animator extends CoreObject {
   /**
    * Constructor.
    * Private to prohibit instantiation from outside the class itself.
    */
   private function Animator() {
      m_animations = new Array();
      m_running = false;
   }

   /**
    * Returns the only instance of the class.
    *
    * @return The global Animator instance.
    */
   public static function getInstance() :Animator {
      if ( m_instance == null ) {
         m_instance = new Animator();
      }
      return m_instance;
   }

   public function run( animation :IAnimation ) :Void {
      // TODO: Check if animation is already added.
      // TODO: Reset animation first?

      // If the animation is already completed (i.e. its duration is zero), we
      // don't need to put it into the render process.
      if ( animation.isCompleted() ) {
         animation.end();
      } else {
         animation.addEventListener( Event.COMPLETE, this, handleAnimationCompleted );
         m_animations.push( animation );

         if ( !m_running ) {
            startEnterFrame();
         }
      }
   }

   /**
    * Stops a currently running animation without jumping to its end.
    *
    * Be aware that any listeners for animation completion might never get
    * called if you don't manually jump to the animation end afterwards.
    *
    * @param animation The animation to stop.
    * @return Whether the animation could be stopped (i.e. if it was running).
    */
   public function stop( animation :IAnimation ) :Boolean {
      var currentAnimation :IAnimation;
      var i :Number = m_animations.length;
      while ( currentAnimation = m_animations[ --i ] ) {
         if ( currentAnimation == animation ) {
            m_animations.splice( i, 1 );
            return true;
         }
      }

      return false;
   }

   private function render( event :Event ) :Void {
      var deltaTime :Number = ( getTimer() - m_lastTicks ) * 0.001;
      m_lastTicks = getTimer();

      // Operate on a copy of the m_animations array to avoid strange effects
      // when handleAnimationComplete() is called while the loop below runs.
      var animations :Array = m_animations.slice();

      var currentAnimation :Animation;
      var i :Number = animations.length;
      while ( currentAnimation = animations[ --i ] ) {
         // The extra check for isCompleted() is necessary because a race
         // condition can be tripped if an animation are ended in a method
         // called by a COMPLETE listener of a second Animation fired by ticking
         // that animation here in this loop.
         if ( !currentAnimation.isCompleted() ) {
            currentAnimation.tick( deltaTime );
         }
      }
   }

   private function startEnterFrame() :Void {
      EnterFrameBeacon.getInstance().addEventListener( Event.ENTER_FRAME,
         this, render );
      m_lastTicks = getTimer();
      m_running = true;
   }

   private function stopEnterFrame() :Void {
      EnterFrameBeacon.getInstance().removeEventListener( Event.ENTER_FRAME,
         this, render );
      m_running = false;
   }

   private function handleAnimationCompleted( event :Event ) :Void {
      var currentAnimation :IAnimation;
      var i :Number = m_animations.length;

      while ( currentAnimation = m_animations[ --i ] ) {
         if ( event.target == currentAnimation ) {
            m_animations.splice( i, 1 );

            if ( m_animations.length == 0 ) {
               stopEnterFrame();
            }

            return;
         }
      }
   }

   private static var m_instance :Animator;

   private var m_animations :Array;
   private var m_running :Boolean;
   private var m_lastTicks :Number;
}
