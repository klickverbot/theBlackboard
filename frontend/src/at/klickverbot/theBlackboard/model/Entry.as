import at.klickverbot.drawing.Drawing;
import at.klickverbot.event.EventDispatcher;
import at.klickverbot.theBlackboard.model.EntryChangeEvent;

class at.klickverbot.theBlackboard.model.Entry extends EventDispatcher {
   public function Entry() {
      m_id = null;
      m_caption = null;
      m_author = null;
      m_drawing = null;
      m_timestamp = null;
      m_loaded = false;

      // Entries are dirty per default since they have to be stored to the
      // backend if they are created locally.
      m_dirty = true;
   }

   public function copyFrom( other :Entry ) :Void {
      this.id = other.id;
      this.caption = other.caption;
      this.author = other.author;
      this.drawing = other.drawing;
      this.timestamp = other.timestamp;
      this.loaded = other.loaded;
      this.dirty = other.dirty;
   }

   public function get id() :Number {
      return m_id;
   }

   public function set id( to :Number ) :Void {
      var oldValue :Number = m_id;
      if ( oldValue != to ) {
         m_id = to;
         this.dirty = true;
         dispatchEvent( new EntryChangeEvent(
            EntryChangeEvent.ID, this, oldValue, to ) );
      }
   }

   public function get caption() :String {
      return m_caption;
   }

   public function set caption( to :String ) :Void {
      var oldValue :String = m_caption;
      if ( oldValue != to ) {
         m_caption = to;
         this.dirty = true;
         dispatchEvent( new EntryChangeEvent(
            EntryChangeEvent.CAPTION, this, oldValue, to ) );
      }
   }

   public function get author() :String {
      return m_author;
   }

   public function set author( to :String ) :Void {
      var oldValue :String = m_author;
      if ( oldValue != to ) {
         m_author = to;
         this.dirty = true;
         dispatchEvent( new EntryChangeEvent(
            EntryChangeEvent.AUTHOR, this, oldValue, to ) );
      }
   }

   public function get drawing() :Drawing {
      return m_drawing;
   }

   public function set drawing( to :Drawing ) :Void {
      var oldValue :Drawing = m_drawing;
      if ( oldValue != to ) {
         m_drawing = to;
         this.dirty = true;
         dispatchEvent( new EntryChangeEvent(
            EntryChangeEvent.DRAWING, this, oldValue, to ) );
      }
   }

   public function get timestamp() :Date {
      return m_timestamp;
   }

   public function set timestamp( to :Date ) :Void {
      var oldValue :Date = m_timestamp;
      if ( oldValue != to ) {
         m_timestamp = to;
         this.dirty = true;
         dispatchEvent( new EntryChangeEvent(
            EntryChangeEvent.TIMESTAMP, this, oldValue, to ) );
      }
   }

   public function get loaded() :Boolean {
      return m_loaded;
   }

   public function set loaded( to :Boolean ) :Void {
      var oldValue :Boolean = m_loaded;
      if ( oldValue != to ) {
         m_loaded = to;
         this.dirty = true;
         dispatchEvent( new EntryChangeEvent(
            EntryChangeEvent.LOADED, this, oldValue, to ) );
      }
   }

   public function get dirty() :Boolean {
      return m_dirty;
   }

   public function set dirty( to :Boolean ) :Void {
      var oldValue :Boolean = m_dirty;
      if ( oldValue != to ) {
         m_dirty = to;
         dispatchEvent( new EntryChangeEvent(
            EntryChangeEvent.DIRTY, this, oldValue, to ) );
      }
   }

   public function isPesistent() :Boolean {
      return m_loaded || !m_dirty;
   }

   private function getInstanceInfo() :Array {
      return super.getInstanceInfo().concat( [
         "id: " + m_id,
         "loaded: " + m_loaded,
         "dirty: " + m_dirty
      ] );
   }

   private var m_id :Number;
   private var m_caption :String;
   private var m_author :String;
   private var m_drawing :Drawing;
   private var m_loaded :Boolean;
   private var m_timestamp :Date;

   private var m_dirty :Boolean;
}
