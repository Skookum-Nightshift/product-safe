var MySafe = React.createClass({
  render: function(){
    return (
      <div className="mySafe">
        <h2>NavBar:</h2>
        <NavBar/>
        <h2>My Collection</h2>
        <CollectionPage/>
      </div>
      )
  }
});



window.MySafe = MySafe;