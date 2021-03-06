var CollectionItem = React.createClass({

  onSelect: function() {
    this.props.onSelect(this.props.item);
  },

  render: function(){
    var item = this.props.item,
        name = item.name? item.name : item.ItemAttributes.Title,
        imageUrl = item.image? item.image : item.LargeImage.URL
        caption = "";

    if (item.caption) {
      caption = (
        <div className="caption expirationFlag">
          <a href="#">{item.caption}</a>
        </div>
      );
    } else {
      caption = (
        <div className="caption" style={{ cursor: 'pointer' }}
          onClick={this.onSelect}>
          Add to vault
        </div>
      )
    }

    return (
      <div className="col-md-3 col-sm-6 col-xs-12 item">
        <img src={imageUrl} alt="placeholder image" class="img-responsive border"/>
        <div className = "overlay"></div>
        {caption}
        <div className="info">
          <a href="#">{name}</a>
        </div>
      </div>
    );
  }
});

window.CollectionItem = CollectionItem;
