var SideBar = React.createClass({
  render: function(){
    return (
        <div className="col-sm-3 col-md-2" role="navigation">
           
            <ul className="nav nav-sidebar">
              <NavItem />
            </ul>
            <ul className="nav nav-sidebar">
              <NavItem />
            </ul>
            <ul className="nav nav-sidebar">
              <NavItem />
            </ul>
          
        </div>
      )
  }
});

window.SideBar = SideBar;