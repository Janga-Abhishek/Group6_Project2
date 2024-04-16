class Post {
   String username;
   String userImage;
   String postImage;
   String postContent;
   bool isLiked;
  bool showFullText;

  Post(this.username, this.userImage, this.postImage, this.postContent, this.isLiked, {this.showFullText = false});
}
