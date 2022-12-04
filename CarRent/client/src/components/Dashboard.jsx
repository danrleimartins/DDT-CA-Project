import CurrentTotals from "./CurrentsTotals"
import { Stack, Box, Flex, Center } from "@chakra-ui/react"
import Car from "./Car"
import Car1 from '../assets/car1.png'
import Car2 from '../assets/car2.png'
import Car3 from '../assets/car3.png'
import RenterForm from "./RenterForm"
import { useContext, useState } from "react"
import { BlockchainContext } from "../context/BlockchainContext"
import ClipLoader from "react-spinners/ClipLoader";

const Dashboard = () => {
    const { renterExists, currentAccount } = useContext(BlockchainContext)
    let [loading, setLoading] = useState(true);
    console.log(renterExists)
    return (
        <Stack
            as={Box}
            textAlign={'center'}
            spacing={{ base: 8, md: 14 }}
            py={{ base: 20, md: 36}}>
        { renterExists == null && currentAccount ? <Center><ClipLoader loading={loading} size={75} /></Center> : renterExists ? <CurrentTotals /> : <RenterForm /> }
        <Flex justifyContent={'center'} alignItems={'center'}>
            <Car car={Car1}/>
            <Car car={Car2}/>
            <Car car={Car3}/>
        </Flex>
        </Stack>
    )
}

export default Dashboard
