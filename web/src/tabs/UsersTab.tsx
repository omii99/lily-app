import React, { useState, useEffect, useContext } from "react"
import styled from "styled-components"
// import { firestore } from "firebase"

import { AppContext } from "../App"
import { Tab, Trait } from "../components"

const Table = styled.table`
  width: 100%;
  border-spacing: 0;
`

const HeaderTitle = styled.td`
  font-weight: bold;
  padding: 16px 12px;
  background-color: #f7f7f7;
`

const RowItem = styled.td`
  padding: 16px 12px;
  border-bottom: 1px solid #f7f7f7;
`

export default function UsersTab() {
  const context = useContext(AppContext)
  const [searchValue, setSearchValue] = useState("")

  const users =[
    {
      id: "00N01121",
      name : "Mandara",
      age : 23,
      gender : "Male",
      personality :
        { 
          name : "x1",
        value : 0.9,
      }

      
    },
    {
      id: "00N01122",
      name : "Sam",
      age : 24,
      gender : "Male",
      personality :
      { 
        name : "x1",
      value : 0.6,
    }
    },
    {
      id: "00N01124",
      name : "Ruwani",
      age : 23,
      gender : "Female",
      personality :
      { 
        name : "x1",
      value : 0.96,
    }
    }
  ]

  // useEffect(
  //   () =>
  //     firestore()
  //       .collection("users")
  //       .onSnapshot(snapshot =>
  //         context.setUsers(
  //           snapshot.docs
  //             .map(doc => ({
  //               id: doc.id,
  //               ...doc.data()
  //             }))
  //             .filter(
  //               (user: any) =>
  //                 searchValue === "" ||
  //                 user.name.toLowerCase().includes(searchValue.toLowerCase())
  //             )
  //         )
  //       ),
  //   [searchValue]
  // )

  return (
    <Tab title="Users" onSearchValueChange={value => setSearchValue(value)}>
      <Table>
        <thead>
          <tr>
            <HeaderTitle>ID</HeaderTitle>
            <HeaderTitle>Name</HeaderTitle>
            <HeaderTitle>Age</HeaderTitle>
            <HeaderTitle>Gender</HeaderTitle>
            <HeaderTitle>Personality</HeaderTitle>
          </tr>
        </thead>
        <tbody>
          {users.map((user: any) => (
            <tr key={user.id}>
              <RowItem>{user.id}</RowItem> 
             
              <RowItem>{user.name}</RowItem>
              
              <RowItem>{user.age}</RowItem>
           
              <RowItem>{user.gender}</RowItem>
             
              <RowItem>
                {user.personality &&
                  Object.entries(
                    user.personality
                  ).map(([trait, value]: any) => (
                    <Trait name={trait} value={value} key={trait} />
                  ))}
              </RowItem>
            </tr>
          ))}
        </tbody>
      </Table>
    </Tab>
  )
}
