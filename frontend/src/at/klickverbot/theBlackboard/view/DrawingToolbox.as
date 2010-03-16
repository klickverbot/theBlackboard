import at.klickverbot.event.events.Event;
import at.klickverbot.debug.Debug;
import at.klickverbot.event.events.ButtonEvent;
import at.klickverbot.event.events.DrawingAreaEvent;
import at.klickverbot.theBlackboard.view.ButtonForNumber;
import at.klickverbot.theBlackboard.view.theme.AppClipId;
import at.klickverbot.theBlackboard.view.theme.ContainerElement;
import at.klickverbot.ui.components.HStrip;
import at.klickverbot.ui.components.McComponent;
import at.klickverbot.ui.components.drawingArea.DrawingArea;
import at.klickverbot.ui.components.themed.Button;
import at.klickverbot.ui.components.themed.MultiContainer;

class at.klickverbot.theBlackboard.view.DrawingToolbox extends McComponent {
   /**
    * Constructor.
    */
   public function DrawingToolbox( drawingArea :DrawingArea ) {
      super();

      m_drawingArea = drawingArea;
      m_drawingArea.addEventListener( DrawingAreaEvent.OP_COMPLETED,
         this, updateHistoryButtons );
      m_drawingArea.addEventListener( DrawingAreaEvent.HISTORY_CHANGE,
         this, updateHistoryButtons );

      setupUi();
   }

   private function createUi() :Boolean {
      if( !super.createUi() ) {
         return false;
      }

      if ( !m_toolboxContainer.create( m_container ) ) {
         return false;
      }

      // "Press" the first button.
      handleColorButtonPress(
         new ButtonEvent( ButtonEvent.PRESS, m_buttonsForColor[ 0 ].button ) );

      handleSizeButtonPress(
         new ButtonEvent( ButtonEvent.PRESS, m_buttonsForSize[ 0 ].button ) );

      updateHistoryButtons();

      return true;
   }

   public function destroy() :Void {
      if ( m_onStage ) {
         m_toolboxContainer.destroy();
      }

      super.destroy();
   }

   private function setupUi() :Void {
      m_toolboxContainer = new MultiContainer( AppClipId.DRAWING_TOOLS_CONTAINER );

      // Add the color buttons.
      m_colorStrip = new HStrip();
      // TODO: Remove this and make the buttons in the theme bigger.
      m_colorStrip.setHSpacing( 10 );

      m_buttonsForColor = new Array();
      for ( var i :Number = 0; i < CLIP_ID_COLOR_TABLE.length; ++i ) {
         var colorButton :Button = new Button( CLIP_ID_COLOR_TABLE[ i ][ CLIP_ID ] );
         colorButton.addEventListener( ButtonEvent.RELEASE, this, handleColorButtonPress );
         m_buttonsForColor.push(
            new ButtonForNumber( colorButton, CLIP_ID_COLOR_TABLE[ i ][ VALUE ] ) );

         m_colorStrip.addContent( colorButton );
      }

      m_toolboxContainer.addContent( ContainerElement.TOOLS_COLORS, m_colorStrip );

      // Add the size buttons.
      m_sizeStrip = new HStrip();
      m_sizeStrip.setHSpacing( 0 );

      m_buttonsForSize = new Array();
      for ( var i :Number = 0; i < CLIP_ID_SIZE_TABLE.length; ++i ) {
         var sizeButton :Button = new Button( CLIP_ID_SIZE_TABLE[ i ][ CLIP_ID ] );
         sizeButton.addEventListener( ButtonEvent.RELEASE, this, handleSizeButtonPress );
         m_buttonsForSize.push(
            new ButtonForNumber( sizeButton, CLIP_ID_SIZE_TABLE[ i ][ VALUE ] ) );

         m_sizeStrip.addContent( sizeButton );
      }

      m_toolboxContainer.addContent( ContainerElement.TOOLS_SIZES, m_sizeStrip );

      // Add the history buttons.
      m_undoButton = new Button( AppClipId.UNDO_BUTTON );
      m_undoButton.addEventListener( ButtonEvent.PRESS, this, handleUndoButtonPress );
      m_toolboxContainer.addContent( ContainerElement.TOOLS_UNDO, m_undoButton );

      m_redoButton = new Button( AppClipId.REDO_BUTTON );
      m_redoButton.addEventListener( ButtonEvent.PRESS, this, handleRedoButtonPress );
      m_toolboxContainer.addContent( ContainerElement.TOOLS_REDO, m_redoButton );

      // Add the next step button.
      m_nextStepButton = new Button( AppClipId.NEXT_STEP_BUTTON );
      m_nextStepButton.oneShotMode = true;
      m_nextStepButton.addEventListener( ButtonEvent.PRESS, this, handleNextStepButtonPress );
      m_toolboxContainer.addContent( ContainerElement.TOOLS_NEXT_STEP, m_nextStepButton );
   }

   private function addColorButtonHandler( target :Button ) :Void {
      target.addEventListener( ButtonEvent.RELEASE, this, handleColorButtonPress );
   }

   private function handleColorButtonPress( event :ButtonEvent ) :Void {
      var pressedButton :Button = Button( event.target );

      for ( var i :Number = 0; i < m_buttonsForColor.length; ++i ) {
         ButtonForNumber( m_buttonsForColor[ i ] ).button.setActive( true );
      }
      pressedButton.setActive( false );

      var color :Number = findNumberForButton( m_buttonsForColor, pressedButton );
      Debug.assertNotNull( color, "No matching table entry for color button: " +
         event.target );

      m_drawingArea.penStyle.color = color;
   }

   private function handleSizeButtonPress( event :ButtonEvent ) :Void {
      var pressedButton :Button = Button( event.target );

      for ( var i :Number = 0; i < m_buttonsForSize.length; ++i ) {
         ButtonForNumber( m_buttonsForSize[ i ] ).button.setActive( true );
      }
      pressedButton.setActive( false );

      var size :Number = findNumberForButton( m_buttonsForSize, pressedButton );
      Debug.assertNotNull( size, "No matching table entry for size button: " +
         event.target );

      m_drawingArea.penStyle.thickness = size;
   }

   private function findNumberForButton( mappings :Array, button :Button ) :Number {
      for ( var i :Number = 0; i < mappings.length; ++i ) {
         var currentMapping :ButtonForNumber = mappings[ i ];
         if ( currentMapping.button == button ) {
            return currentMapping.number;
         }
      }

      return null;
   }


   private function handleUndoButtonPress( event :ButtonEvent ) :Void {
      m_drawingArea.undo( 1 );
   }

   private function handleRedoButtonPress( event :ButtonEvent ) :Void {
      m_drawingArea.redo( 1 );
   }

   private function handleNextStepButtonPress( event :ButtonEvent ) :Void {
      dispatchEvent( new Event( Event.COMPLETE, this ) );
   }

   private function updateHistoryButtons( event :DrawingAreaEvent ) :Void {
      m_undoButton.setActive( ( m_drawingArea.getUndoStepsPossible() >= 1 ) );
      m_redoButton.setActive( ( m_drawingArea.getRedoStepsPossible() >= 1 ) );
   }

   private static var CLIP_ID_COLOR_TABLE :Array = [
      [ AppClipId.WHITE_BUTTON, 0xEEEEEE ],
      [ AppClipId.YELLOW_BUTTON, 0xDDDD00 ],
      [ AppClipId.RED_BUTTON, 0xBB0000 ],
      [ AppClipId.GREEN_BUTTON, 0x009900 ],
      [ AppClipId.BLUE_BUTTON, 0x000088 ],
      [ AppClipId.BLACK_BUTTON, 0x111111 ]
   ];

   private static var CLIP_ID_SIZE_TABLE :Array = [
      [ AppClipId.SIZE_1_BUTTON, 5 ],
      [ AppClipId.SIZE_2_BUTTON, 8 ],
      [ AppClipId.SIZE_3_BUTTON, 20 ],
      [ AppClipId.SIZE_4_BUTTON, 30 ],
      [ AppClipId.SIZE_5_BUTTON, 40 ]
   ];

   private static var CLIP_ID :Number = 0;
   private static var VALUE :Number = 1;

   private var m_drawingArea :DrawingArea;

   private var m_toolboxContainer :MultiContainer;

   private var m_colorStrip :HStrip;
   private var m_buttonsForColor :Array;

   private var m_sizeStrip :HStrip;
   private var m_buttonsForSize :Array;

   private var m_undoButton :Button;
   private var m_redoButton :Button;

   private var m_nextStepButton :Button;
}
