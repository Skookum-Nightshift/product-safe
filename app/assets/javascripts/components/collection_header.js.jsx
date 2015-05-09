var CollectionHeader = React.createClass({
  getInitailState: function() {
    return {
      searchTerm: ""
    };
  },

  updateSearchTerm: function() {
    this.setState({
      searchTerm: this.refs.searchInput.getDOMNode().value
    });
  },

  handleSubmit: function(e) {
    if (e.keyCode === 13) {
      this.props.openLink('SearchResultsView', '/search', '/api/search',
        { search_term: this.state.searchTerm });
    }
  },

  render: function(){
    return (
      <div className="container collectionHeader">
        <div className="row">
          <span>My Collection</span>
        </div>
        <div className="searchBar">
          <input type="text" placeholder="Search my Collection" ref="searchInput"
            onChange={this.updateSearchTerm} onKeyDown={this.handleSubmit} />
        </div>
      </div>
    );
  }
});

window.CollectionHeader = CollectionHeader;
