var SideBar = React.createClass({
  render: function(){
    return (
        <div class="col-sm-3 col-md-2 sidebar-offcanvas" id="sidebar" role="navigation">
           
            <ul class="nav nav-sidebar">
              <NavItem />
            </ul>
            <ul class="nav nav-sidebar">
              <NavItem />
            </ul>
            <ul class="nav nav-sidebar">
              <NavItem />
            </ul>
          
        </div>
      )
  }
});

window.SideBar = SideBar;