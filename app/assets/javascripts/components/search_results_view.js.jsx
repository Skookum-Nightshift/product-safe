var SearchResultsView = React.createClass({

  getInitialState: function() {
    return {
      items: [],
      page: 1,
      lastScrollTop: 0,
      gettingMoreItems: false
    };
  },

  componentWillMount: function() {
    this.setState({ items: this.props.items });
    $(document).bind("scroll", this.watchScroll);
  },

  componentWillUnmount: function() {
    $(document).unbind("scroll", this.watchScroll);
  },

  watchScroll: function(event) {
    var self = this;
    var target = $(document),
        scrollTop = $(window).scrollTop() + $(window).height(),
        isScrollDown = scrollTop > this.state.lastScrollTop,
        scrollableHeight = $(document).height(),
        percent = 100 / scrollableHeight;
    console.log((percent*scrollTop), scrollableHeight, scrollTop);
    if (isScrollDown && (percent*scrollTop) > 90) {
      if (this.state.gettingMoreItems) { return; }
      this.setState({gettingMoreItems: true}, function(){
        self.getMoreItems();
      });
    } else {
      this.setState({ lastScrollTop: scrollTop });
    }
  },

  getMoreItems: function() {
    var page = this.state.page+1;
    var self = this;
    this.setState({ page: page }, function(){
      csrfGet('api/search/', { page: page, search_term: this.props.searchTerm }, function(data) {
        var items = self.state.items;
        for(var i=0; i < data.items.length; i++) {
          items.push(data.items[i]);
        }
        console.log(items);
        self.setState({ items: items, gettingMoreItems: false });
      }, function(){
        self.setState({page: self.state.page-1, gettingMoreItems: false });
      });
    });

  },

  render: function() {
    return (
      <CollectionBody items={this.state.items} onScroll={this.watchScroll} />
    );
  }
});

window.SearchResultsView = SearchResultsView;
