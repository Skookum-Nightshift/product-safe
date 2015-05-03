var CollectionItem = React.createClass({
  render: function(){
    var items = this.props.items.map(function(item){
      return (
        
          <ItemInformation item = {item} />
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