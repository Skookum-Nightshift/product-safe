var CollectionBody = React.createClass({
  render: function(){
    var items = this.props.items;
    return (
        <div className="container collectionBody">
          <CollectionRow items={items}/>
        </div>
      )
  }
});

window.CollectionBody = CollectionBody;