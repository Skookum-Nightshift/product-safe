var SideBar = React.createClass({
  render: function(){
    return (
        <div className="core-sidebar" role="navigation">
            <img src={this.props.logo} className="side-logo" />
            <ul className="nav nav-sidebar">
              <NavItem title="LINK" link='#' realLink={true}  />
            </ul>
            <ul className="nav nav-sidebar">
              <NavItem title="LINK" link='#' realLink={true}  />
            </ul>
            <ul className="nav nav-sidebar">
              <NavItem title="sign out" link='/users/sign_out' realLink={true} method="delete" />
            </ul>

        </div>
      )
  }
});

window.SideBar = SideBar;
