var CollectionHeader = React.createClass({
  render: function(){
    return (
        <div className="collectionHeader">
          <span>My Collection</span>
          <SearchBar />
        </div>
      )
  }
});

window.CollectionHeader = CollectionHeader;