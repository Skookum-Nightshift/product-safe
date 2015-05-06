var CollectionHeader = React.createClass({
  render: function(){
    return (
        <div className="container collectionHeader">
          <div className="row">
            <span>My Collection</span>
          </div>
          <div className="searchBar">
                <form>
                    <input type="text" placeholder="Search my Collection" />
                </form>
            </div>
        </div>
      )
  }
});

window.CollectionHeader = CollectionHeader;