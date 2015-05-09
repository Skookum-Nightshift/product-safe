var MySafe = React.createClass({
  render: function(){
    var items = this.props.items;
    return (
      <div className="row mySafe">
        <CollectionPage items={items} openLink={this.props.openLink} />
      </div>
    );
  }
});

window.MySafe = MySafe;
