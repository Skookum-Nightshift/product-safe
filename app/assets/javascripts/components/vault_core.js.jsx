var VaultCore = React.createClass({
  getInitialState: function() {
    return {
      content: []
    };
  },

  componentDidMount: function() {
    window.onpopstate = this.handleHistoryPopState;

    this.goToPage(this.props.componentName, this.props.url, this.props.apiUrl, {},
      window.history.replaceState.bind(window.history));
  },

  componentWillUnmount: function() {
    window.removeEventListener('onpopstate', this.handleHistoryPopState);
  },

  handleHistoryPopState: function(e) {
    if (e.state) {
      this.renderPage(e.state.componentName, e.state.data);
    }
  },

  goToPage: function(componentName, url, apiUrl, queryData, historyFunc) {
    queryData = queryData || {};
    historyFunc = historyFunc || window.history.pushState.bind(window.history);
    if (apiUrl) {
      var self = this;
      csrfGet(apiUrl, queryData, function(data) {
        self.renderPage(componentName, data, url, historyFunc);
      });
    } else {
      this.renderPage(componentName, {}, url, historyFunc);
    }
  },

  renderPage: function(componentName, data, url, historyFunc) {
    data.openLink = this.goToPage;
    var Component = window[componentName];
    var content = [<Component key={'core-'+componentName+'-'+url} {...data} />];
    this.setState({ content: content }, function() {
      data.openLink = null;
      if (historyFunc) {
        var historyState = {
          componentName: componentName,
          data: data
        };
        historyFunc(historyState, '', url);
      }
      document.title = data.documentTitle || 'Vault';
    });
  },

  render: function() {
    return (
      <div className='vault-core'>
        <SideBar />
        <CollectionHeader openLink={this.goToPage} />
        <div className='content'>
          {this.state.content}
        </div>
      </div>
    );
  }
});

window.VaultCore = VaultCore;
