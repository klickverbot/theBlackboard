import at.klickverbot.theme.ClipId;

/**
 * Clip ids for the MovieClips from the theme for this application.
 * The purpose in using this class instead of just the plain strings is to
 * collect all needed MovieClips in one place to make creating a new theme from
 * scratch easier.
 */
class at.klickverbot.theBlackboard.view.theme.AppClipId extends ClipId {
   /**
    * Constructor.
    * Private to prohibit instantiation from outside the class itself.
    */
   private function AppClipId( id :String ) {
      super( id );
   }

   public static var MAIN_CONTAINER :AppClipId = new AppClipId( "mainContainer" );
   public static var TOOLBAR_CONTAINER :AppClipId = new AppClipId( "toolbarContainer" );
   public static var ENTRIES_DISPLAY_CONTAINER :AppClipId = new AppClipId( "entriesDisplayContainer" );
   public static var DRAW_ENTRY_CONTAINER :AppClipId = new AppClipId( "drawEntryContainer" );
   public static var DRAWING_TOOLS_CONTAINER :AppClipId = new AppClipId( "drawingToolsContainer" );
   public static var ENTRY_DETAILS_CONTAINER :AppClipId = new AppClipId( "entryDetailsContainer" );
   public static var CAPTCHA_AUTH_CONTAINER :AppClipId = new AppClipId( "captchaAuthContainer" );
   public static var VIEW_SINGLE_CONTAINER :AppClipId = new AppClipId( "viewSingleContainer" );

   public static var DEFAULT_TEXT_BOX :AppClipId = new AppClipId( "defaultTextBox" );

   public static var TOOLTIP_LABEL :AppClipId = new AppClipId( "tooltipLabel" );
   public static var ENTRY_TOOLTIP :AppClipId = new AppClipId( "entryTooltip" );
   public static var PAGE_DISPLAY :AppClipId = new AppClipId( "pageDisplay" );
   public static var ENTRY_DETAILS_DISPLAY :AppClipId = new AppClipId( "entryDetailsDisplay" );

   public static var PREVIOUS_PAGE_BUTTON :AppClipId = new AppClipId( "previousPageButton" );
   public static var NEXT_PAGE_BUTTON :AppClipId = new AppClipId( "nextPageButton" );
   public static var NEW_ENTRY_BUTTON :AppClipId = new AppClipId( "newEntryButton" );
   public static var WHITE_BUTTON :AppClipId = new AppClipId( "whiteButton" );
   public static var YELLOW_BUTTON :AppClipId = new AppClipId( "yellowButton" );
   public static var RED_BUTTON :AppClipId = new AppClipId( "redButton" );
   public static var GREEN_BUTTON :AppClipId = new AppClipId( "greenButton" );
   public static var BLUE_BUTTON :AppClipId = new AppClipId( "blueButton" );
   public static var BLACK_BUTTON :AppClipId = new AppClipId( "blackButton" );
   public static var SIZE_1_BUTTON :AppClipId = new AppClipId( "size1Button" );
   public static var SIZE_2_BUTTON :AppClipId = new AppClipId( "size2Button" );
   public static var SIZE_3_BUTTON :AppClipId = new AppClipId( "size3Button" );
   public static var SIZE_4_BUTTON :AppClipId = new AppClipId( "size4Button" );
   public static var SIZE_5_BUTTON :AppClipId = new AppClipId( "size5Button" );
   public static var ERASER_BUTTON :AppClipId = new AppClipId( "eraserButton" );
   public static var UNDO_BUTTON :AppClipId = new AppClipId( "undoButton" );
   public static var REDO_BUTTON :AppClipId = new AppClipId( "redoButton" );
   public static var SUBMIT_BUTTON :AppClipId = new AppClipId( "submitButton" );
   public static var DISCARD_BUTTON :AppClipId = new AppClipId( "discardButton" );
   public static var BACK_TO_INDEX_BUTTON :AppClipId = new AppClipId( "backToIndexButton" );

   public static var BACKGROUND :AppClipId = new AppClipId( "background" );
   public static var BACK_SCENERY :AppClipId = new AppClipId( "backScenery" );
   public static var FRONT_SCENERY :AppClipId = new AppClipId( "frontScenery" );
   public static var MODAL_OVERLAY_BACKGROUND :AppClipId = new AppClipId( "modalOverlayBackground" );
   public static var ENTRY_LOADING_INDICATOR :AppClipId = new AppClipId( "entryLoadingIndicator" );

   public static var DEFAULT_POINTER :AppClipId = new AppClipId( "defaultPointer" );
   public static var PEN_POINTER :AppClipId = new AppClipId( "penPointer" );
   public static var ERASER_POINTER :AppClipId = new AppClipId( "eraserPointer" );
}
