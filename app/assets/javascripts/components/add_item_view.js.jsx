var AddItemView = React.createClass({
  render: function(){
    return (
      <div className="row addItemView">
        <div className="col-md-12">
          <input type="button" className="btn btn-danger" >Amazon</input>
          <input type="button" className="btn btn-danger">Barcode</input>
        </div>
      </div>
    );
  }
});

window.AddItemView = AddItemView;
