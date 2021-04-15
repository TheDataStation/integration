{
  user: 'max',
  access_token: '1234567',
  task: {
    type: 'classification',
    search_time: 60,
    payload: {
      y_col: 'Name',
      drop_cols: [],
      data_path: "./testres/view_0"
    },
  },
  dos: {
    metric: 'accuracy',
    range: [0.8, 1],
  },
  trust_constraints: {
    freshness: 'last_week',
    user: 'all_groups',
  },
}
