var CollectionItem = React.createClass({
  render: function(){
    var items = this.props.items.map(function(item){
      return (
        
          
            <div className="col-md-3 col-sm-6 col-xs-12 item">
              <img src="http://placegant.me/pg/300/300" alt="placeholder image" class="img-responsive border"/>
              <div className = "overlay"></div>
              <div className="caption expirationFlag">
                <a href="#">Caption</a>
              </div>
              <div className="info">
                <a href="#">{item.name}</a>
              </div>
            </div>

        
      )
    });

    return(
      <div>
      {items}
      </div>
      )
  }
});

window.CollectionItem = CollectionItem;