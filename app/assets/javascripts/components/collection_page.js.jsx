var CollectionPage = React.createClass({
  render: function(){
    var items = this.props.items;
    return (
        <div className="col-sm-9 col-md-10 collectionPage">
          <div className="row">
            <CollectionHeader />
            <CollectionBody items={items} />
          </div>
        </div>
      )
  }
});

window.CollectionPage = CollectionPage;