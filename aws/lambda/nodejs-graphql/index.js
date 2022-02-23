const { ApolloServer, gql } = require("apollo-server-lambda");
const {
  ApolloServerPluginLandingPageGraphQLPlayground,
} = require("apollo-server-core");

const typeDefs = gql`
  type Echo {
    message: String!
    echo(message: String): Echo!
  }

  type Query {
    echo(message: String!): Echo!
  }
`;

const resolvers = {
  Echo: {
    echo: (parent, args, { dataSources }, info) => {
      const parentMessage = parent.message;
      const { message } = args;

      if (message) {
        return { message };
      } else {
        return { message: parentMessage };
      }
    },
  },
  Query: {
    echo: (parent, args, context, info) => {
      const { message } = args;
      return { message };
    },
  },
};

const server = new ApolloServer({
  typeDefs: typeDefs,
  resolvers: resolvers,
  introspection: true,
  plugins: [ApolloServerPluginLandingPageGraphQLPlayground],
});

exports.handler = server.createHandler();