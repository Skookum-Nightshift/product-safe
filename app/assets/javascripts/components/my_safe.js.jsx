var MySafe = React.createClass({
  render: function(){
    var items = this.props.items;
    return (
      <div>
        <div className="row mySafe">
          <CollectionPage items={items} openLink={this.props.openLink} />
        </div>
      </div>
    );
  }
});

window.MySafe = MySafe;
