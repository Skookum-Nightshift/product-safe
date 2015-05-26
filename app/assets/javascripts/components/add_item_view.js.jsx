var AddItemView = React.createClass({
  getInitialState: function() {
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
      this.props.openLink('SearchResultsView', '/', '/api/search',
        { search_term: this.state.searchTerm });
    }
  },

  render: function(){
    return (
      <div className="row addItemView">
        <div className="col-md-12">
          <div className="searchBar">
          <input type="text" placeholder="Add from Amazon" ref="searchInput"
            onChange={this.updateSearchTerm} onKeyDown={this.handleSubmit} />
        </div>
        </div>
      </div>
    );
  }
});

window.AddItemView = AddItemView;
