var ItemInformation = React.createClass({
  
  render: function(){
    var item = this.props.items;
    return (
        <div className="info">
          <div className="col-md-3 col-sm-6 col-xs-12 item">
          <img src="http://placegant.me/pg/300/300" alt="placeholder image" class="img-responsive border"/>
          <div className = "overlay"></div>
          <div className="caption expirationFlag">
            <a href="#">Caption</a>
          </div>
          <a href="#">{item.name}</a>
        </div>
        </div>
      )
  }
});

window.ItemInformation = ItemInformation;