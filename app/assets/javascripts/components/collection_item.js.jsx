var CollectionItem = React.createClass({
  render: function(){
    return (
        <div className="col-md-3 col-sm-6 col-xs-12 item">
          <img src="http://placegant.me/pg/300/300" alt="placeholder image" class="img-responsive border"/>
          <div className = "overlay"></div>
          <ExpirationFlag />
        </div>
      )
  }
});

window.CollectionItem = CollectionItem;