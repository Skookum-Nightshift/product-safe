var CollectionHeader = React.createClass({
  render: function(){
    return (
        <div className="container collectionHeader">
          <div className="row">
            <span>My Collection</span>
          </div>
          <div className="searchBar">
                <form action="/search/item_search" method="get">
                    <input type="text" placeholder="Search my Collection" />
                </form>
            </div>
        </div>
      )
  }
});

window.CollectionHeader = CollectionHeader;