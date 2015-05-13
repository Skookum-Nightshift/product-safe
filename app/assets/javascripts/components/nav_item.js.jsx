var NavItem = React.createClass({

  openLink: function() {
    if (!this.props.realLink) {
      this.props.openLink(this.props.component, this.props.link, this.props.api_link);
    }
  },

  render: function() {
    var link = this.props.realLink? (
      <a href={this.props.link} data-method={this.props.method}>{this.props.title}</a>
    ) : this.props.title;

    return (
      <li className="active" onClick={this.openLink}>{link}</li>
    )
  }
});

window.NavItem = NavItem;
