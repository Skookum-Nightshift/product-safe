var CollectionBody = React.createClass({
  render: function(){
    var items = this.props.items.map(function(item) {
      return <CollectionItem item={item} onSelect={this.props.onSelect} />;
    }, this);

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
