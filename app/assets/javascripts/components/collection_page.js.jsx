var CollectionPage = React.createClass({
  render: function(){
    return (
        <div className="col-sm-9 col-md-10 collectionPage">
          <div className="row">
            <CollectionHeader />
            <CollectionBody />
          </div>
        </div>
      )
  }
});

window.CollectionPage = CollectionPage;