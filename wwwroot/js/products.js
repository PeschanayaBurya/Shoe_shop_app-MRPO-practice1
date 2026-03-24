(function () {
    const container = document.getElementById('productsContainer');
    if (!container) {
        return;
    }

    const canManageFilters = container.dataset.canManageFilters === 'true';
    if (!canManageFilters) {
        return;
    }

    const searchInput = document.getElementById('searchInput');
    const supplierFilter = document.getElementById('supplierFilter');
    const sortOrder = document.getElementById('sortOrder');

    let debounceTimer = null;

    function loadProducts() {
        const params = new URLSearchParams();
        const searchValue = searchInput ? searchInput.value.trim() : '';
        const supplierValue = supplierFilter ? supplierFilter.value : '';
        const sortValue = sortOrder ? sortOrder.value : '';

        if (searchValue) {
            params.append('search', searchValue);
        }

        if (supplierValue) {
            params.append('supplierId', supplierValue);
        }

        if (sortValue) {
            params.append('sortOrder', sortValue);
        }

        fetch(`/Products/ListPartial?${params.toString()}`, {
            method: 'GET',
            headers: {
                'X-Requested-With': 'XMLHttpRequest'
            }
        })
            .then(function (response) {
                if (!response.ok) {
                    throw new Error('Product list loading failed.');
                }
                return response.text();
            })
            .then(function (html) {
                container.innerHTML = html;
            })
            .catch(function () {
                container.innerHTML = '<div class="message message-error"><strong>Error:</strong> Could not refresh product list.</div>';
            });
    }

    function debouncedLoad() {
        window.clearTimeout(debounceTimer);
        debounceTimer = window.setTimeout(loadProducts, 250);
    }

    if (searchInput) {
        searchInput.addEventListener('input', debouncedLoad);
    }

    if (supplierFilter) {
        supplierFilter.addEventListener('change', loadProducts);
    }

    if (sortOrder) {
        sortOrder.addEventListener('change', loadProducts);
    }
})();
