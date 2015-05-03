var MySafe = React.createClass({
  render: function(){
    var items = this.props.items;
    return (
      <div className="row mySafe">
        <h2>SideBar:</h2>
        <SideBar />
        <CollectionPage items={items} />
      </div>
      )
  }
});



window.MySafe = MySafe;