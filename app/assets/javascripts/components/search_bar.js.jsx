var SearchBar = React.createClass({
    render: function() {
        return (
            <div className="searchBar">
                <form>
                    <input type="text" placeholder="Search my Collection" />
                </form>
            </div>
        )
    }
});

window.SearchBar = SearchBar;