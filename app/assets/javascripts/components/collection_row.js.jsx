var CollectionRow = React.createClass({
  render: function(){
    var items = this.props.items;
    return (
        <div className="row collectionRow">
          <CollectionItem items={items}/>
          <CollectionItem />
          <CollectionItem />
        </div>
      )
  }
});

window.CollectionRow = CollectionRow;