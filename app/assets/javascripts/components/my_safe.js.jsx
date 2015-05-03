var MySafe = React.createClass({
  render: function(){
    return (
      <div className="row mySafe">
        <h2>SideBar:</h2>
        <SideBar />
        <CollectionPage />
      </div>
      )
  }
});



window.MySafe = MySafe;