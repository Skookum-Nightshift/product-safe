var MySafe = React.createClass({
  render: function(){
    return (
      <div className="mySafe">
        <h2>SideBar:</h2>
        <SideBar />
        <CollectionHeader />
        <CollectionPage />
      </div>
      )
  }
});



window.MySafe = MySafe;