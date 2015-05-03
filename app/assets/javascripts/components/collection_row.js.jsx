var CollectionRow = React.createClass({
  render: function(){
    return (
        <div className="row collectionRow">
          <CollectionItem />
          <CollectionItem />
          <CollectionItem />
        </div>
      )
  }
});

window.CollectionRow = CollectionRow;