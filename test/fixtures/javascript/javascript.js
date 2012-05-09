
/**~ GetImageSize:
 *
 * This file showcase the use of JavaDoc, multi line and single line sherpa blocks.
 *
 * Arguments:
 * - src      - The path to the image requesting the size of
 * - callback - The callback function to execute after obtaining the image size
 *
 * Examples:
 *    var image_size = new GetImageSize('/images/image.png', gotImageSize);
 */
(function() {

  var GetImageSize = function(src, callback) {
    this.src = src;
    this.callback = callback;
  };

  /*~
   * ### `#requestImageSize`
   * Uses a multi line sherpa block
   *
   *    image_size.requestImageSize();
   */
  GetImageSize.prototype.requestImageSize = function () {
    // This comment doesn't get parsed by sherpa
    var self = this;
  };

  //~
  // #### `#dispose`
  // Uses a single line sherpa block
  //
  //    image_size.dispose();
  GetImageSize.prototype.dispose = function() {
    delete this.src;
    delete this.callback;
  };
}())

