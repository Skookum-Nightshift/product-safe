var CollectionBody = React.createClass({
  render: function(){
    var items = this.props.items.map(function(item) {
      return <CollectionItem item={item} />;
    });

    return (
        <div className="container collectionBody">
          <div className="row collectionRow">
            {items}
          </div>
        </div>
      )
  }
});

window.CollectionBody = CollectionBody;
