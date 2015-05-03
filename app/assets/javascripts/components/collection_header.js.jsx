var CollectionHeader = React.createClass({
  render: function(){
    return (
        <div className="container collectionHeader">
          <div className="row">
            <span>My Collection</span>
            <SearchBar />
          </div>
        </div>
      )
  }
});

window.CollectionHeader = CollectionHeader;